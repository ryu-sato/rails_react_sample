import React, { useEffect, useState } from 'react'
import PropTypes from 'prop-types'

import axios from 'axios'

function Parent(props) {
  const [children, setChildren] = useState([]);

  useEffect(() => {
    axios
      .get(`/api/v1/parents/${props.id}/children`)
      .then(response => {
        const newChildren = response.data.data;
        setChildren(newChildren);
      })
      .catch(() => {
        console.log('Some error occured.');
      });
  }, []);  // 初回レンダ時にだけ実行される

  const tabs = children.map((c, index) => 
    <li
      key={`child-tab-${c.id}`}
      className={ index === 0 ? "nav-item active" : "nav-item" }
      role="presentation">
      <button
        className="nav-link"
        id={`child-tab-${c.id}`}
        data-bs-toggle="tab"
        data-bs-target={`#child-${c.id}`}
        type="button"
        role="tab"
      >
        {c.attributes.name}
      </button>
    </li>
  );
  const childContents = children.map((c, index) => 
    <div
      key={`child-content-${c.id}`}
      className={ index === 0 ? "tab-pane fade show active" : "tab-pane fade" }
      id={`child-${c.id}`}
      role="tabpanel"
      aria-labelledby={`child-tab-${c.id}`}
    >
      {c.attributes.name}
    </div>
  );
  
  return(
    <>
      <ul className="nav nav-tabs" role="tablist">
        {tabs}
      </ul>
      <div className="tab-content">
        {childContents}
      </div>
    </>
  );
};

Parent.defaultProps = {
  id: 0,
  name: "UNKNOWN"
}

Parent.propTypes = {
  id: PropTypes.number,
  name: PropTypes.string
}

export default Parent;
