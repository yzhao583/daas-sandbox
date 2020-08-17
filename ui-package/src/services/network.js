import { createClient } from "webdav/web";

const baseUrl =
  "http://localhost:1901";
const credential = {
  username: "grumpy",
  password: "webdavpsd",
};

class NetworkService {
  static connect = () => {
    return createClient(baseUrl, credential);
  };

  static getFiles = (client) => {
    return new Promise((resolve, reject) => {
      if (client) {
        client.getDirectoryContents("/resources").then(
          (response) => {
            if (response) {
              resolve(response);
            }
          },
          (error) => {
            reject(error.message);
          }
        );
      } else {
          reject("No server client provided");
      }
    });
  };

  static getFile = (client, fileName) => {
    return new Promise((resolve, reject) => {
      if (client && fileName) {
        client.getFileContents(fileName, { format: "text" }).then(
          (response) => {
            if (response) {
              resolve(response);
            }
          },
          (error) => {
            reject(error.message);
          }
        );
      } else {
          reject("No server client provided");
      }
    });
  };

  static updateFile = (client, fileName, data) => {
    return new Promise((resolve, reject) => {
      if (client && fileName && data) {
        client.putFileContents(fileName, data).then(
          (response) => {
            if (response) {
              resolve(response);
            }
          },
          (error) => {
            reject(error.message);
          }
        );
      } else {
          reject("No server client provided");
      }
    });
  };

}

export default NetworkService;
