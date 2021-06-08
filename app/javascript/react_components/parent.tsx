import React, { useEffect, useState } from 'react';

import axios from 'axios';

interface ParentProps {
  id: number;
  name: string;
}

const Parent = (props: ParentProps): JSX.Element => {
  const [children, setChildren] = useState([]);
  const [newChild, setNewChild] = useState({ name: '' });
  const [selectedChildId, setSelectedChildId] = useState(0);

  useEffect(() => getChildren(), [props.id]);

  const getChildren = () => {
    axios
      .get(`/api/v1/parents/${props.id}/children`)
      .then((response) => {
        const newChildren = response.data.data;
        setChildren(newChildren);
        setSelectedChildId(newChildren[0].id);
      })
      .catch(() => {
        console.log('Some error occured.');
      });
  };
  const addChild = () => {
    axios
      .post(`/api/v1/parents/${props.id}/children`, newChild)
      .then((response) => {
        const newChild = response.data.data;
        setChildren([...children, newChild]);
      })
      .catch(() => {
        console.log('Some error occured.');
      });
  };

  const tabs = children.map(c => (
    <li className="nav-item" key={`child-tab-${c.id}`}>
      <button
        className={selectedChildId === c.id ? 'nav-link active' : 'nav-link'}
        id={`child-tab-${c.id}`}
        type="button"
        data-bs-toggle="tab"
        data-bs-target={`#child-${c.id}`}
      >
        {c.attributes.name}
      </button>
    </li>
  ));
  const newChildTab = (
    <li className="nav-item" role="presentation" key="new-child">
      <button
        className="nav-link"
        id="child-tab-new"
        data-bs-toggle="tab"
        data-bs-target="#child-new"
        type="button"
        role="tab"
      >
        <i className="fas fa-plus-circle"></i>
      </button>
    </li>
  );
  tabs.push(newChildTab);

  const childContents = children.map(c => (
    <div
      key={`child-${c.id}`}
      className={
        selectedChildId === c.id
          ? 'my-3 tab-pane fade show active'
          : 'my-3 tab-pane fade'
      }
      id={`child-${c.id}`}
    >
      <div className="mb-3 row">
        <label htmlFor="childName" className="col-sm-2 col-form-label">
          Name
        </label>
        <div className="col-sm-10">{c.attributes.name}</div>
      </div>
    </div>
  ));
  const newChildContent = (
    <div
      key="new-child-content"
      className="my-3 tab-pane fade"
      id="child-new"
      role="tabpanel"
      aria-labelledby="child-tab-new"
    >
      <div className="mb-3 row">
        <label htmlFor="childName" className="col-sm-2 col-form-label">
          Name
        </label>
        <div className="col-sm-10">
          <input
            id="childName"
            type="text"
            className="form-control"
            onChange={e => setNewChild({ ...newChild, name: e.target.value })}
          />
        </div>
      </div>
      <div className="row">
        <div className="col-sm-12 justify-content-end">
          <button
            type="button"
            className="btn btn-primary mb-3 btn-sm"
            onClick={() => addChild()}
          >
            Add
          </button>
        </div>
      </div>
    </div>
  );
  childContents.push(newChildContent);

  return (
    <>
      <ul className="nav nav-tabs" role="tablist">
        {tabs}
      </ul>
      <div className="tab-content">{childContents}</div>
    </>
  );
};

export default Parent;
