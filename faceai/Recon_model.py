import torch
import numpy as np
from torchvision import transforms
import os
import copy
import cv2
import PIL
from PIL import Image
from PIL import ImageOps
import dlib
import pickle
from inception_resnet_v1 import InceptionResnetV1


class Recon_model(object):

    def __init__(self):

        self.tran = transforms.ToTensor() 
        self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

        print("Loading model .")
        self.model = InceptionResnetV1(pretrained='vggface2', classify=True,  device=self.device)
        self.model.eval()
        print("Model loading success .")
        
        print(" Initializing Face detector .")
        self.face_detector = dlib.get_frontal_face_detector()
        print("Face detector initialized")

    def default_image_loader(self,path):
        image = cv2.imread(path)
        # image = np.asarray(PIL.Image.open(path))
        # image = PIL.Image.open(path)


        return image
    
    def align_shapePredictor(self, img, fname):

        try:
            # Run the HOG face detector on the image data
            img_shapePredictor =  self.face_detector(img)
            face = img[img_shapePredictor[0].top():img_shapePredictor[0].bottom(), img_shapePredictor[0].left():img_shapePredictor[0].right()]
            # img = Image.fromarray(img.astype('uint8'), 'RGB')
            # face = ImageOps.crop(img,(img_shapePredictor[0].left(), img_shapePredictor[0].top(), img_shapePredictor[0].right(), img_shapePredictor[0].bottom()))
            alignedFace = cv2.resize(face,(160, 160)) 
            # cv2.imwrite(fname,alignedFace)
            return alignedFace
        except Exception as e:
            print(e)
            print("Error detecting face")
            return None

    
    def create_profiles(self, profile_name, profile_filenames):
        
        profile_list = []
        for profile_filenames_item in profile_filenames:
            
            img = self.default_image_loader(profile_filenames_item)
            img = self.align_shapePredictor(img, profile_filenames_item)
            vector = self.model(self.tran(img).unsqueeze(0))
            
            profile_list.append(vector)
            
        max_diff = []    
        for idx0, vector_item0 in enumerate(profile_list):
            for idx1, vector_item1 in enumerate(profile_list):
                
                if idx0 != idx1:
                    max_diff.append((vector_item0 - vector_item1).norm().item())
                    
        vector_diff_max = max(max_diff)
        
        profile_list =  [vector_diff_max] + profile_list       
        with open( os.getcwd() + "/profiles/"+ profile_name +"_list.bin", 'wb') as file:
            pickle.dump(profile_list, file)
        
        return "Profile creation succesfull for " + profile_name
            
    def compare_profiles(self, profile_name, profile_filename):
    
        img = self.default_image_loader(profile_filename)
        img = self.align_shapePredictor(img, profile_filename)
        vector = self.model(self.tran(img).unsqueeze(0))

        if os.path.exists(os.getcwd() + "/profiles/"+ profile_name +"_list.bin"):
            with open(os.getcwd() + "/profiles/"+ profile_name +"_list.bin", 'rb') as file:
                profile_vectors = pickle.load(file)
        else:
            return "Profile " + profile_name + " not found."
        
        thres = copy.deepcopy(profile_vectors[0])
        thres = 216 if thres <= 216 else thres
        del profile_vectors[0]

        for profile_vectors_item in profile_vectors:
            if (profile_vectors_item - vector).norm().item() < thres:
                return True
            
        return False
            
            

if __name__ == "__main__":

    recon_model = Recon_model()
    print(recon_model.create_profiles('profile1', ['uploads/1.jpg','uploads/2.jpg','uploads/3.jpg','uploads/4.jpg','uploads/5.jpg']))
    print(recon_model.compare_profiles('profile1','uploads/000002.jpg'))