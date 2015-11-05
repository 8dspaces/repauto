import React, {Component, PropTypes} from 'react';
import TrendGraph from './Graph';
import { pushState } from 'redux-router';
import { connect } from 'react-redux';
import _ from 'lodash';
import { fetch, filter, invalidate } from '../../modules/TestRun';

@connect(
  state => ({
    path: state.router.location.pathname
  }),
  {filter, pushState, invalidate}
)
export default class Card extends Component {
  _jumpToDetail(name) {
    const{invalidate, filter, pushState, path} = this.props;
    console.info('jump to', name);
    invalidate();
    filter(name);
    pushState(null, `${path}/runs`);
  }

  render() {
    const {title, data} = this.props;
    var heading = [
      <h3 key='heading' className='panel-title pull-left'>
        {title}
      </h3>,
      <a key='search'
        href={this.props.url}
        className='btn btn-primary pull-right'
        onClick={() => this._jumpToDetail(title)}>
        <i className='fa fa-search' />
      </a>
    ];
    var graph = (
      <TrendGraph data={data} />
    );
    var lastRun = (
      <h5 className='list-group-item-heading'>Last Run</h5>
    );
    return (
      <div className='panel panel-default'>
        <div className='panel-heading clearfix'>
          {heading}
        </div>
        <div className='list-group'>
          <div className='list-group-item'>
            {graph}
          </div>
          <div className='list-group-item'>
            {lastRun}
          </div>
        </div>
      </div>
    );
  }
};
