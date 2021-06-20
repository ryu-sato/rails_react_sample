// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from 'react';
import ReactDOM from 'react-dom';

import Parent from '../react_components/parent';
import Search from '../react_components/search';
import '../locales/i18n';
import I18nSample from '../react_components/I18nSample';

document.addEventListener('DOMContentLoaded', () => {
  const ep = document.querySelector('#parent');
  if (ep) {
    const parentsData = JSON.parse(ep.dataset.reactData).data;
    const parents = parentsData.map(p => (
      <Parent {...p.attributes} key={p.id} />
    ));
    ReactDOM.render(<div>{parents}</div>, ep);
  }

  const es = document.querySelector('#full-text-search');
  if (es) {
    const searchData = es.dataset;
    const search = <Search {...searchData} />;
    ReactDOM.render(<div>{search}</div>, es);
  }
  
  const i18nDom = document.querySelector('#i18n');
  if (i18nDom) {
    const i18nSample = <I18nSample />;
    ReactDOM.render(i18nSample, i18nDom);
  }
});
