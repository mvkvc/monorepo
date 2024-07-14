import fs from "fs";
import axios from "axios";
import { hashFile } from "./files";
import { logger } from "./logger";

export const requestPresignedURL = async (
  URL: string,
  APIKey: string,
  key: string
): Promise<string> => {
  try {
    const response = await axios.get(URL, {
      headers: {
        Authorization: `Bearer ${APIKey}`,
      },
      params: {
        key,
      },
    });
    return response.data;
  } catch (error) {
    throw new Error(error.message);
  }
};

export const uploadFile = async (
  URL: string,
  APIKey: string,
  key: string,
  filePath: string
): Promise<boolean> => {
  try {
    const presignedURL = await requestPresignedURL(URL, APIKey, key);
    const hash = await hashFile(filePath);
    const fileStream = fs.createReadStream(filePath);
    const responseS3 = await axios.put(presignedURL, fileStream, {
      headers: {
        "Content-Type": "application/octet-stream",
      },
    });
    const responseUpload = await axios.post(
      URL,
      {
        key,
        hash,
      },
      {
        headers: {
          Authorization: `Bearer ${APIKey}`,
        },
      }
    );

    return responseS3.status === 200 && responseUpload.status === 200;
  } catch (error) {
    logger.error(error);
    return false;
  }
};

export const notifyFile = async () => {};

export const notifyFolder = async () => {};
