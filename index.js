
const moment = require('moment');
const simpleGit = require('simple-git');

const DATE = moment().subtract(7.5, 'months').format();
simpleGit().add("./*").commit("Update TD", {'--date': DATE}).push();