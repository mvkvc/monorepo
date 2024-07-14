import { DataTypes, QueryInterface } from "sequelize";
import { MigrationParams, RunnableMigration } from "umzug";
import type { Migration } from "../main/schema";

const name: string = "01_createFilesTable";

const up: Migration = async (params: MigrationParams<QueryInterface>) => {
  await params.context.createTable("files", {
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
};

const down: Migration = async (params: MigrationParams<QueryInterface>) => {
  await params.context.dropTable("files");
};

const migration: RunnableMigration<QueryInterface> = {
  name,
  up,
  down,
};

export default migration;
