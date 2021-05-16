import request from '@/utils/myrequest'

export function getConfigList(params) {
  return request({
    url: '/diamond-server/basestone.do',
    method: 'GET',
    params
  })
}
export function getConfig(params) {
  return request({
    url: '/diamond-server/config.co',
    method: 'GET',
    params
  })
}
export function getGroups() {
  return request({
    url: '/diamond-server/basestone.do',
    method: 'GET',
    params:{method:"groups"}
  })
}
export function saveConfig(data) {
  return request({
    url: '/diamond-server/basestone.do',
    method: 'POST',
    data:data
  })
}
export function rmConfig(params) {
  return request({
    url: '/diamond-server/config.co',
    method: 'DELETE',
    params
  })
}




