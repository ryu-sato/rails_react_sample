// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from "react";
import ReactDOM from "react-dom";

import Parent from "../react_components/parent";

document.addEventListener("DOMContentLoaded", () => {
  const e = document.querySelector("#parent");
  const parents_data = JSON.parse(e.dataset.reactData).data;
  const parents = parents_data.map((p) => (
    <Parent {...p.attributes} key={p.id} />
  ));

  ReactDOM.render(<div>{parents}</div>, e);
});
