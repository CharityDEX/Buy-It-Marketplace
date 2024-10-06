final loginRegex = RegExp(r'^[a-zA-Z0-9\.\-_@]{1,50}$');
final usernameRegex = RegExp(r'^[a-zA-Z0-9\-_]{1,50}$');
final passwordRegex =
    RegExp(r'^[a-zA-Z0-9`~!@#$%^&*()_|+\-=?;:",.<>\{\}\[\]\\\/]{6,50}$');
final emailRegex =
    RegExp(r'^[a-zA-Z0-9\._\-]+@[a-zA-Z0-9\.\-_]+\.[a-zA-Z0-9\.\-_]+$');
