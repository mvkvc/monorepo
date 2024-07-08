import React from "react";
import { NavLink } from "react-router-dom";

export default function Header() {
  const routes = {
    "/": "Sources",
    "/settings": "Settings",
  };

  return (
    <div className="flex flex-row justify-between items-center p-4">
      <div>
        <h1 className="text-3xl font-bold">Exboost</h1>
      </div>
      <ul className="flex flex-row space-x-4">
        {Object.entries(routes).map(([path, name]) => (
          <li key={path}>
            <NavLink to={path} className="btn">
              {name}
            </NavLink>
          </li>
        ))}
      </ul>
    </div>
  );
}
