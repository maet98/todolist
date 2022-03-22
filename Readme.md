# To-Do List App
For running this project locally:

1. Install docker and make command

2. Go to the ./mobile/lib/utils/constant.dart and change uriApi to your local address

```dart
const String uriApi = "http://10.0.0.5:3000";
```

3. Run the following command to install dependencies and build the backend.

```
make install
```

4. Then run the following command to run the project.

```
make run
```

5. If you want to stop the backend, run the following command.
```
make down_backend
```
