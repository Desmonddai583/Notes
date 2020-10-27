/* @flow */

import * as nodeOps from 'web/runtime/node-ops' // dom操作的方法
import { createPatchFunction } from 'core/vdom/patch'
import baseModules from 'core/vdom/modules/index'
import platformModules from 'web/runtime/modules/index'

// the directive module should be applied last, after all
// built-in modules have been applied.
const modules = platformModules.concat(baseModules)

// 这个patch方法是通过 createPatchFunction函数返回回来的
export const patch: Function = createPatchFunction({ nodeOps, modules })
