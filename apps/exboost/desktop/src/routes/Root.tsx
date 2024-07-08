import React from "react";
import { Outlet } from "react-router-dom";
import Header from "../components/header";

export default function Root() {
  return (
    <>
      <div className="flex flex-col">
        <Header />
        <div className="p-8">
          <Outlet />
        </div>
      </div>
    </>
  );
}
