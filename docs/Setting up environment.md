## Setting up local environment

### Prerequisites

WSL2 is required to run the project locally. You can follow the
instructions [here](https://learn.microsoft.com/en-us/windows/wsl/install) to install WSL2 on your machine.

### Installation

1. Clone the repository

```sh
git clone https://github.com/Jake55111/MarketHandler 
```

2. Set up and activate the virtual environment

```sh
python3 -m venv venv
```

```sh
source venv/bin/activate
```

4. Install the dependencies

```sh
pip install -r requirements.txt
```

5. Install redis

```sh
sudo apt install redis
```

6. Install and configure MySQL. It is recommended to change the password to something else than "password". If you do so, you will have to change the password in the config.json file.

```sh
sudo apt install mysql-server
```

```sh
sudo systemctl start mysql.service
```

```sh
sudo mysql
```

```sh
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
```

```sh
exit
```

```sh
sudo mysql_secure_installation
```

```sh
mysql -u root -p
```

```sh
ALTER USER 'root'@'localhost' IDENTIFIED WITH auth_socket;
```

```sh
CREATE USER 'market'@'localhost' IDENTIFIED BY 'password';
```

```sh
GRANT ALL PRIVILEGES ON *.* TO 'market'@'localhost';
```

```sh
FLUSH PRIVILEGES;
```

```sh
exit
```

After this, environment will be set up. If you run main.py with the ```-b``` parameter, it will set up the tables.

If you wish to populate the database with statistic data, run main.py with the ```-f RELICSRUN -d NEW``` parameters.


