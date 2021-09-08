
# Overview
This is a data pipeline, constructed in datajoint, used across Princeton's U19.
It specifies a number of tables and their relational structure to organizes all metadata to
* mouse mangament,
* training management,
* microscope management,
* und recording

in one coherent framework.

# Connection to database
1. Install datajoint for matlab 
      
      a) Utilize MATLAB built-in GUI i.e. Top Ribbon -> Add-Ons -> Get Add-Ons
      
      b) Search and Select DataJoint
      
      c) Select Add from GitHub
      
2. Clone this repository.
3. Add this repository to your Matlab Path.         
4. ``` setenv('DB_PREFIX', 'u19_') ```
5. ``` dj.conn('datajoint00.pni.princeton.edu') (Enter username and password) ```

# Mounting data files on your system
There are several data files (behavior, imaging & electrophysiology) that are referenced in the database
To access thse files you should mount PNI file server volumes on your system.
There are three main file servers across PNI where data is stored (braininit, Bezos & u19_dj)

### On windows systems
- From Windows Explorer, select "Map Network Drive" and enter: <br>
    [\\\bucket.pni.princeton.edu\braininit\\]() (for braininit) <br>
    [\\\bucket.pni.princeton.edu\Bezos\\]()     (for Bezos) <br>
    [\\\bucket.pni.princeton.edu\u19_dj\\]()   (for u19_dj) <br>
- Authenticate with your **NetID and PU password** (NOT your PNI password, which may be different). When prompted for your username, enter PRINCETON\netid (note that PRINCETON can be upper or lower case) where netid is your PU NetID.
  
### On OS X systems
- Select "Go->Connect to Server..." from Finder and enter: <br>
    [smb://bucket.pni.princeton.edu/braininit/]()    (for braininit) <br>
    [smb://bucket.pni.princeton.edu/Bezos/]()    (for Bezos) <br>
    [smb://bucket.pni.princeton.edu/u19_dj/]()   (for u19_dj) <br>
- Authenticate with your **NetID and PU password** (NOT your PNI password, which may be different).

### On Linux systems
- Follow extra steps depicted in this link: https://npcdocs.princeton.edu/index.php/Mounting_the_PNI_file_server_on_your_desktop

### Notable data 
Here are some shortcuts to common used data accross PNI

**Towers Task Sue Ann**
- Imaging: [/Bezos-center/RigData/scope/bay3/sakoay/{protocol_name}/imaging/{subject_nickname}/]() 
- Behavior: [/braininit/RigData/scope/bay3/sakoay/{protocol_name}/data/{subject_nickname}/]()

**Widefield Lucas Pinto**
- Imaging [/braininit/RigData/VRwidefield/widefield/{subject_nickname}/{session_date}/]()
- Behavior [/braininit/RigData/VRwidefield/behavior/lucas/blocksReboot/data/{subject_nickname}/]()

**Opto inactivacion experiments Lucas Pinto**
- Imaging [/braininit/RigData/VRLaser/LaserGalvo1/{subject_nickname}/]()
- Behavior [/braininit/RigData/VRLaser/behav/lucas/blocksReboot/data/{subject_nickname}/]()

### Reading behavior files directly from Database
1. Mount needed file server
2. Connect to the Database
3. Create a structure with subject_fullname and session_date from the session <br>
```key.subject_fullname = 'koay_K65'``` <br>
```key.session_Date = '2018-02-05'``` <br>
4. Read file <br>
```[status, data] = lab.utils.read_behavior_file(key)```

### Get path info from the session
1. Mount needed file server
2. Connect to the Database
3. Create a structure with subject_fullname and session_date from the session <br>
```key.subject_fullname = 'koay_K65'``` <br>
```key.session_Date = '2018-02-05'``` <br>
4. Fetch filepath info:
```data_dir = fetch(acquisition.SessionStarted & key, 'remote_path_behavior_file');``` <br>
```[~, filepath] = lab.utils.get_path_from_official_dir(data_dir.remote_path_behavior_file);```


# Go through Tutorial
Follow the steps to go through the tutorial:
1. Fork the repository to your own GitHub account
2. Clone from your own GitHub repository. 
3. Get into the directory of the current tutorial `tutorials/202001/`
4. Run `startup.m`
5. Put in the username and password when they prompt
6. Run live scripts session01 and session02

# Backend
The backend is a SQL server [MariaDB].

# Integration into rigs.
The rigs talk to the database directly [SSL, wired connection].

