// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'

const Parent = props => (
  <div>Hello {props.name}</div>
)

Parent.defaultProps = {
  name: "UNKNOWN"
}

Parent.propTypes = {
  name: PropTypes.string
}

document.addEventListener('DOMContentLoaded', () => {
  const e = document.querySelector("#parent");
  const parents_data = JSON.parse(e.dataset.reactData).data;
  const parents = parents_data.map((p) => <Parent name={p.attributes.name} key={p.id} />);
  ReactDOM.render(
    <div>{parents}</div>,
    e,
  )
})
