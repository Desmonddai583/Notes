import axios from 'axios';

export const fetchUser = () => {
    return axios.get('/user');
}

export const fetchList = () => {
   // return axios.get('/list');
}

export const sum = (a, b) => {
    return a + b;
}