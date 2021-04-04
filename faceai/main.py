from flask import Flask
from flask import Response, jsonify, request, redirect, url_for

#persistent storage in dictionary
import shelve

#printing ip of host
import socket

#file uploading
import os
from werkzeug.utils import secure_filename

#serving files that were uploaded
from flask import send_from_directory

from Recon_model import Recon_model 


#mac-specific relative path to the script's location
UPLOAD_FOLDER = 'uploads'

recon_model = Recon_model()

#configuration
app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route('/', methods=['GET', 'POST'])
def select_oprtation():
    return '''
    <!doctype html>
    <title>Select Action</title>
    <h1>Upload new File</h1>
    <form action="" method=post enctype=multipart/form-data>
    <p><a href="http://localhost:5000/create_profile/">Create Profile</a>
    <br>
    <a href="http://localhost:5000/reconcile_profile/">Reconcile Profile</a>
    </form>

        '''

@app.route('/create_profile/', methods=['GET', 'POST'])
def create_vector_profile():
    try:
        os.stat(app.config['UPLOAD_FOLDER'])
    except:
        os.mkdir(app.config['UPLOAD_FOLDER'])
    if request.method == 'POST':
        profile_name = request.form['profile_name']
        file1 = request.files['file1']
        file2 = request.files['file2']
        file3 = request.files['file3']
        file4 = request.files['file4']
        file5 = request.files['file5']

        filename1 = secure_filename(file1.filename)
        filename2 = secure_filename(file2.filename)
        filename3 = secure_filename(file3.filename)
        filename4 = secure_filename(file4.filename)
        filename5 = secure_filename(file5.filename)
        
        filepath1 = os.path.join(app.config['UPLOAD_FOLDER'], filename1)
        filepath2 = os.path.join(app.config['UPLOAD_FOLDER'], filename2)
        filepath3 = os.path.join(app.config['UPLOAD_FOLDER'], filename3)
        filepath4 = os.path.join(app.config['UPLOAD_FOLDER'], filename4)
        filepath5 = os.path.join(app.config['UPLOAD_FOLDER'], filename5)
        
        file1.save(filepath1)
        file2.save(filepath2)
        file3.save(filepath3)
        file4.save(filepath4)
        file5.save(filepath5)

        return_str = recon_model.create_profiles(profile_name, [filepath1,filepath2,filepath3,filepath4,filepath5])
        return return_str
    
    return '''
        <!doctype html>
        <title>Upload new File</title>
        <h1>Upload new File</h1>
        <form action="" method=post enctype=multipart/form-data>
        <p><input type="text" name="profile_name">
        <input type=file name=file1>
        <input type=file name=file2>
        <input type=file name=file3>
        <input type=file name=file4>
        <input type=file name=file5>
        <input type=submit value=Upload>
        </form>

        '''
@app.route('/reconcile_profile/', methods=['GET', 'POST'])
def reconcile_profile():
    try:
        os.stat(app.config['UPLOAD_FOLDER'])
    except:
        os.mkdir(app.config['UPLOAD_FOLDER'])
    if request.method == 'POST':
        profile_name = request.form['profile_name']
        file = request.files['file']
        
        filename = secure_filename(file.filename)

        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
  
        file.save(filepath)

        return_val = recon_model.compare_profiles(profile_name, filepath)
        return str(return_val)
    
    return '''
        <!doctype html>
        <title>Upload new File</title>
        <h1>Upload new File</h1>
        <form action="" method=post enctype=multipart/form-data>
        <p><input type="text" name="profile_name">
        <input type=file name=file>
        <input type=submit value=Upload>
        </form>
        '''
    
# @app.route('/uploads/<filename>')
# def uploaded_file(filename):
#     return send_from_directory(app.config['UPLOAD_FOLDER'],
#                                filename)


if __name__ == '__main__':

    print(socket.gethostbyname(socket.gethostname()))
    app.run(host='0.0.0.0')