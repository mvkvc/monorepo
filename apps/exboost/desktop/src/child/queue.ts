import { logger } from "../main/logger";
import { QueueConfig, Queue } from "../main/queue";
import { WatcherMessage } from "../main/watcher";
import { File } from "../main/schema";
import { hashFile } from "../main/files";

interface QueueStartMessage {
  action: "start";
  data: QueueConfig;
}

interface QueueStopMessage {
  action: "stop";
  data: null;
}

interface QueuePushMessage {
  action: "push";
  data: WatcherMessage;
}

type QueueMessage = QueueStartMessage | QueueStopMessage | QueuePushMessage;

let queue: Queue<WatcherMessage>;

const PROCESS_BATCH_SIZE = 10;
const PROCESS_INTERVAL_MS = 500;
const handleFn = async (message: WatcherMessage) => {
  const { type, path } = message;

  if (type === "add" || type === "change") {
    const fileHash = await hashFile(path);
    const file = await File.findOne({ where: { path } });

    if (file.dataValues.hash !== fileHash) {
      await File.update(
        { hash: fileHash },
        { where: { id: file.dataValues.id } }
      );
      // Upload file to server
      // Report to server file changed
    }
  } else if (type === "unlink") {
    await File.destroy({ where: { path } });
    // Report to server file deleted
  }
};

process.on("message", (message: QueueMessage) => {
  const { action, data } = message;

  switch (action) {
    case "start":
      logger.info("Queue started", data);
      const { queueFilePath } = data;
      queue = new Queue(
        queueFilePath,
        PROCESS_BATCH_SIZE,
        PROCESS_INTERVAL_MS,
        handleFn
      );
      break;
    case "stop":
      queue?.stopProcessing();
      break;
    case "push":
      queue?.push(data);
      break;
  }
});

process.on("disconnect", async () => {
  queue?.stopProcessing();
  await queue?.saveQueue();
});
