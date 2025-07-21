

import 'package:kohira/view/utils/widget/pop.dart';

void handleHttpError(int statusCode) {
  switch (statusCode) {
    case 400:
      ToastificationError.Error("Bad Request (400): The server could not understand the request.");
      break;
    case 401:
      ToastificationError.Error("Unauthorized (401): Access is denied due to invalid credentials.");
      break;
    case 403:
      ToastificationError.Error("Forbidden (403): You don't have permission to access this resource.");
      break;
    case 404:
      ToastificationError.Error("Not Found (404): The requested resource could not be found.");
      break;
    case 408:
      ToastificationError.Error("Request Timeout (408): The server timed out waiting for the request.");
      break;
    case 409:
      ToastificationError.Error("Conflict (409): The request could not be completed due to a conflict.");
      break;
    case 422:
      ToastificationError.Error("Unprocessable Entity (422): The request was well-formed but was unable to be followed due to semantic errors.");
      break;
    case 429:
      ToastificationError.Error("Too Many Requests (429): You have sent too many requests in a given amount of time.");
      break;
    case 500:
      ToastificationError.Error("Internal Server Error (500): Something went wrong on the server.");
      break;
    case 502:
      ToastificationError.Error("Bad Gateway (502): Invalid response from the upstream server.");
      break;
    case 503:
      ToastificationError.Error("Service Unavailable (503): The server is not ready to handle the request.");
      break;
    case 504:
      ToastificationError.Error("Gateway Timeout (504): The server is acting as a gateway and did not receive a timely response.");
      break;
    default:
      ToastificationError.Error("Unexpected Error ($statusCode): An unknown error occurred.");
  }
}