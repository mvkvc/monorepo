import { Sequelize, DataTypes } from "sequelize";
import { Umzug, SequelizeStorage } from "umzug";
import { getDBPath } from "./config";
import createFoldersTable from "../migrations/00_createFoldersTable";
import createFilesTable from "../migrations/01_createFilesTable";

const sequelize = new Sequelize({
  dialect: "sqlite",
  storage: getDBPath(),
});

export const umzug: Umzug = new Umzug({
  migrations: [createFoldersTable, createFilesTable],
  context: sequelize.getQueryInterface(),
  storage: new SequelizeStorage({
    sequelize,
  }),
  logger: console,
});

export type Migration = typeof umzug._types.migration;

export const Folder = sequelize.define("folders", {
  id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    primaryKey: true,
    autoIncrement: true,
  },
  path: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
  },
});

export const File = sequelize.define("files", {
  id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    primaryKey: true,
    autoIncrement: true,
  },
  path: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
  },
  hash: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  folderId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: "folders",
      key: "id",
    },
    onDelete: "CASCADE",
  },
});
