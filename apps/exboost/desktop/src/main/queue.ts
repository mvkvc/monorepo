import { ChildProcess, fork } from "child_process";
import fs from "fs/promises";
import path from "path";

export interface QueueConfig {
  queueFilePath: string;
  URL: string;
  APIKey: string;
}

export class Queue<T> {
  private queue: T[] = [];
  private queueFilePath: string;
  private processBatchSize: number;
  private processIntervalMS: number;
  private processingIntervalId: NodeJS.Timeout | null = null;

  constructor(
    queueFilePath: string,
    processBatchSize: number,
    processIntervalMS: number,
    handleFn: (data: T) => any,
  ) {
    this.queueFilePath = queueFilePath;
    this.processBatchSize = processBatchSize;
    this.processIntervalMS = processIntervalMS;

    this.loadQueue();

    this.processingIntervalId = setInterval(() => {
      const result = this.pop(this.processBatchSize);
      if (result.length > 0) {
        for (const entry of result) {
          handleFn(entry);
        }
      }
    }, this.processIntervalMS);
  }

  private async loadQueue(): Promise<void> {
    try {
      const file = await fs.readFile(this.queueFilePath, "utf8");
      if (file) {
        this.queue = JSON.parse(file);
      }
    } catch (error) {
      console.error(error);
      this.queue = [];
    }
  }

  async saveQueue(): Promise<void> {
    try {
      const encodedQueue = JSON.stringify(this.queue);
      await fs.writeFile(this.queueFilePath, encodedQueue);
    } catch (error) {
      console.error(error);
    }
  }

  push(data: T): void {
    this.queue.push(data);
  }

  pop(n: number): T[] {
    return this.queue.splice(0, n);
  }

  stopProcessing(): void {
    if (this.processingIntervalId) {
      clearInterval(this.processingIntervalId);
      this.processingIntervalId = null;
    }
  }
}

export const startQueue = (
  queueProcess: ChildProcess,
  queueConfig: QueueConfig,
): ChildProcess => {
  queueProcess?.kill();

  const queuePath = path.join(__dirname, "queue.js");
  queueProcess = fork(queuePath);
  queueProcess.send({ action: "start", data: queueConfig });

  return queueProcess;
};
