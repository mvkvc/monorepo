import { DataTypes, QueryInterface } from "sequelize";
import { MigrationParams, RunnableMigration } from "umzug";
import type { Migration } from "../main/schema";

const name: string = "00_createFoldersTable";

const up: Migration = async (params: MigrationParams<QueryInterface>) => {
  await params.context.createTable("folders", {
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
};

const down: Migration = async (params: MigrationParams<QueryInterface>) => {
  await params.context.dropTable("folders");
};

const migration: RunnableMigration<QueryInterface> = {
  name,
  up,
  down,
};

export default migration;
