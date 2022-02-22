# U19 MATLAB Pipeline
This is a data pipeline, constructed in DataJoint, used across Princeton's U19.
It specifies a number of tables and their relational structure to organizes all metadata to
* mouse management,
* training management,
* microscope management,
* und recording

in one coherent framework.

## Installation
+ The following instructions will detail two types of installation methods.
  1. User installation to access and fetch data from the database.
  2. Developer installation to set up the pipeline for running analysis and fetching data.

### Prerequisite
+ Install DataJoint for MATLAB 
	+ Utilize MATLAB built-in GUI i.e. Top Ribbon -> Add-Ons -> Get Add-Ons
	+ Search, select, and install DataJoint      

### User installation
+ The following instructions will allow a user to access and fetch data from the database.

  <details>
  <summary>Click to expand details</summary>

	+ Set the schema prefix
		```
		setenv('DB_PREFIX', 'u19_')
		```

	+ Connect to the database server
		```
		dj.conn('datajoint00.pni.princeton.edu') (Enter username and password)
		```

	+ Create temporary files for accessing the schema.
		```
		dj.createSchema('imaging', '/scratch', 'u19_imaging_rec_element')
		addpath('/scratch')
		```

	+ List the available tables in a schema.
		```
		imaging.v
		```

	+ Query entries from the database
		```
		query = imaging.v.ActivityTrace() & 'recording_process_id=23';
		```

	+ Fetch data from the database
		```
		activity_trace = fetch(query, 'activity_trace');
		```

	</details>

### Developer installation
+ The following instructions will allow a user to set up the pipeline for running analysis and fetching data.

  <details>
  <summary>Click to expand details</summary>

	+ Clone this repository.
	```
	git clone https://github.com/<GitHub username>/U19-pipeline_matlab.git
	```

	+ Add this repository to your MATLAB Path.

	+ Create a `dj_local_conf.json` within the repository.
	```json
	{
		"database_host": "datajoint00.pni.princeton.edu",
		"database_user": "<username>",
		"database_password": "<password>",
		"database.port": 3306,
		"connection.init_function": null,
		"database.reconnect": true,
		"enable_python_native_blobs": true,
		"loglevel": "INFO",
		"safemode": true,
		"display.limit": 7,
		"display.width": 14,
		"display.show_tuple_count": true,
		"stores": {},
		"custom": {
			"database.prefix": "u19_"
		}
	}
	```

	+ At the start of each MATLAB session, run `init.m`

  </details>

## Tutorial
Follow the steps to go through the tutorial:
1. Get into the directory of the current tutorial `tutorials/202103/`
2. (Skip if already connected to the DB): run `startup.m`
      - Put in the username and password when they prompt1. 
       
3. Choose your tutorial
   * Querying data (**Strongly recommended**) 
     * go through `session01_queries_fetches.mlx`

    * Building analysis pipeline (Recommended only if you are going to create new databases or tables for analysis) 
      * go through `session02_build_pipeline.mlx`

## Accessing data files on your system
+ There are several data files (behavior, imaging & electrophysiology) that are referenced in the database
+ To access these files you should mount PNI file server volumes on your system.
+ There are three main file servers across PNI where data is stored (braininit, Bezos & u19_dj)

	<details>
	<summary>Click to expand details</summary>

	### On windows systems
	- From Windows Explorer, select "Map Network Drive" and enter: <br>
	[\\\cup.pni.princeton.edu\braininit\\]() (for braininit) <br>
	[\\\cup.pni.princeton.edu\Bezos-center\\]()     (for Bezos) <br>
	[\\\cup.pni.princeton.edu\u19_dj\\]()   (for u19_dj) <br>
	- Authenticate with your **NetID and PU password** (NOT your PNI password, which may be different). When prompted for your username, enter PRINCETON\netid (note that PRINCETON can be upper or lower case) where netid is your PU NetID.

	### On OS X systems
	- Select "Go->Connect to Server..." from Finder and enter: <br>
	[smb://cup.pni.princeton.edu/braininit/]()    (for braininit) <br>
	[smb://cup.pni.princeton.edu/Bezos-center/]()    (for Bezos) <br>
	[smb://cup.pni.princeton.edu/u19_dj/]()   (for u19_dj) <br>
	- Authenticate with your **NetID and PU password** (NOT your PNI password, which may be different).

	### On Linux systems
	- Follow extra steps depicted in this link: https://npcdocs.princeton.edu/index.php/Mounting_the_PNI_file_server_on_your_desktop

	### Notable data 
	Here are some shortcuts to common used data accross PNI

	**Sue Ann's Towers Task**
	- Imaging: [/Bezos-center/RigData/scope/bay3/sakoay/{protocol_name}/imaging/{subject_nickname}/]() 
	- Behavior: [/braininit/RigData/scope/bay3/sakoay/{protocol_name}/data/{subject_nickname}/]()

	**Lucas Pinto's Widefield**
	- Imaging [/braininit/RigData/VRwidefield/widefield/{subject_nickname}/{session_date}/]()
	- Behavior [/braininit/RigData/VRwidefield/behavior/lucas/blocksReboot/data/{subject_nickname}/]()

	**Lucas Pinto's Opto inactivacion experiments**
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

	### Get path info for the session behavioral file
	1. Mount needed file server
	2. Connect to the Database
	3. Create a structure with subject_fullname and session_date from the session <br>
	```key.subject_fullname = 'koay_K65'``` <br>
	```key.session_Date = '2018-02-05'``` <br>
	4. Fetch filepath info:
	```data_dir = fetch(acquisition.SessionStarted & key, 'remote_path_behavior_file');``` <br>
	```[~, filepath] = lab.utils.get_path_from_official_dir(data_dir.remote_path_behavior_file);```

</details>

## Backend
The backend is a SQL server [MariaDB].

## Integration into rigs.
The rigs talk to the database directly [SSL, wired connection].

