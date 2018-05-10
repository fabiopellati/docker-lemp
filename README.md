## Docker LEMP


### Frontend Application

localhost:8092

put source code for frontend application in  ./src/frontapp

or create symbolic link
```console
rm -rf ./src/frontapp/
ln -sT /your/frontend/source/path/ ./src/frontapp
```


### Backend Application
localhost:8090

put source code for backend application (api) in  ./src/backapp

or create symbolic link
```console
rm -rf ./src/backapp/
ln -sT /your/backend/source/path/ ./src/backapp
```

### adminer
localhost:8091
