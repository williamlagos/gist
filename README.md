# gist

GitHub Gist Application for iPhone, used for authentication and commenting on Gists with QR-Code scanning. The development followed the strategy below:

* AVFoundation library with AVCaptureSession for the capture and read process of the QR-Code
* Foundation library with URLSession to capture HTTP requests and needed authentication via OAuth
* UIKit for the graphical user interface for commenting and login on app
