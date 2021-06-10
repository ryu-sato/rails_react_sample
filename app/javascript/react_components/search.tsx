import React, { useState } from 'react';
import axios from 'axios';

interface SearchProps {
  disabled: boolean;
}

const Search = (props: SearchProps): JSX.Element => {
  const [searchingText, setSearchingText] = useState('');
  const [asRegexp, setAsRegexp] = useState(false);
  const [searchResult, setSearchResult] = useState({
    hits: [],
    highlights: [],
  });

  const fullTextSearch = () => {
    const searchApiPath = '/api/v1/search';
    const query = `regexp=${asRegexp ? 'true' : 'false'}&q=${searchingText}`;

    axios
      .get(`${searchApiPath}?${query}`)
      .then((response) => {
        setSearchResult(response.data);
      })
      .catch(() => {
        console.log('Some error occured.');
      });
  };

  return (
    <>
      <div className="input-group">
        <input
          type="text"
          className="form-control"
          acceptCharset="utf-8"
          placeholder={props.disabled ? '検索不可' : '全文検索'}
          onChange={e => setSearchingText(e.target.value)}
        />
        <button
          className={`btn btn-outline-secondary btn-sm ${
            asRegexp ? 'active' : ''
          }`}
          type="button"
          onClick={() => setAsRegexp(!asRegexp)}
        >
          (.*)
        </button>
      </div>
      <button
        className="btn btn-primary"
        type="button"
        onClick={fullTextSearch}
      >
        Search
      </button>
      <div>
        { searchResult.hits.map(h => JSON.stringify(h)) }
      </div>
    </>
  );
};

export default Search;
