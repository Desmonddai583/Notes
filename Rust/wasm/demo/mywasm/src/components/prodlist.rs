extern crate wasm_bindgen;
use serde::{Deserialize, Serialize};

use web_sys::HtmlInputElement;

use yew::prelude::*;
use yew::{html, Component, Html};
use yew::html::Scope;

use std::cmp::Ordering;
use std::collections::{HashSet};

#[derive(Debug, Serialize, Deserialize)]
struct ProdModel {
    pid: i32,
    pname: String,
    price: f32,
}

fn cmp(a: &ProdModel, b: &ProdModel) -> Ordering {
    if a.price == b.price {
        return Ordering::Equal;
    }
    if a.price > b.price {
        return Ordering::Greater;
    }
    Ordering::Less
}
fn new_prod(pid: i32, pname: String, price: f32) -> ProdModel {
    ProdModel {
        pid: pid,
        pname: pname,
        price: price,
    }
}
fn gen_prods() -> Vec<ProdModel> {
    (0..5)
        .map(|item| {
            let index = item + 1001;
            new_prod(index, format!("prod{}", index), (index * 10) as f32)
        })
        .collect::<Vec<ProdModel>>()
}
static mut _ID: i32 = -1;
pub struct ProdList {
    prods: Vec<ProdModel>,
    rows: HashSet<Option<i32>>,
    is_desc: bool,
    edit_info: (i32, usize), //first is prod_id,second is index of vec[prods]
    edit_cells: HashSet<Option<i32>>, // edited prods cells
}
pub enum Msg {
    Select(i32),
    Sort(),
    Edit(i32),
    EditCell(String),
    New(),
}

impl Component for ProdList {
    type Message = Msg;
    type Properties = ();
    fn create(_ctx: &Context<Self>) -> Self {
        ProdList {
            prods: gen_prods(),
            rows: HashSet::new(),
            is_desc: false,
            edit_info: (0, 0),
            edit_cells: HashSet::new(),
        }
    }
    fn rendered(&mut self, _ctx: &Context<Self>, first_render: bool) {
        if first_render {}
    }
    fn update(&mut self, _ctx: &Context<Self>, msg: Self::Message) -> bool {
        match msg {
            Msg::Select(i) => {
                if self.rows.contains(&Some(i)) {
                    self.rows.remove(&Some(i));
                } else {
                    self.rows.insert(Some(i));
                }
            }
            Msg::Sort() => {
                if self.is_desc {
                    self.prods.sort_by(|a, b| cmp(a, b));
                } else {
                    self.prods.sort_by(|a, b| cmp(b, a));
                }
                self.is_desc = !self.is_desc;
            }
            Msg::Edit(pid) => {
                // enter cell edit
                self.edit_info.0 = pid;
                for (index, item) in self.prods.iter().enumerate() {
                    if item.pid == pid {
                        self.edit_info.1 = index;
                        break;
                    }
                }
            }
            Msg::EditCell(value) => {
                self.prods[self.edit_info.1].pname = value.clone();
                //save edited-id into edited-cells
                self.edit_cells.insert(Some(self.edit_info.0));
            }
            Msg::New() => {
                unsafe{
                    _ID-=1;
                    self.prods.insert(0, new_prod(_ID, String::new(), 0.0));
                }
            
            }
        }
        true
    }
    fn view(&self, ctx: &Context<Self>) -> Html {
        html! {
            <div id="app" >
            <table>
             <thead>
                <tr>
                    <td colspan="4">
                        <button onclick={ctx.link().callback(|_| Msg::New())} class="button">{"新增"}</button>
                    </td>
                </tr>
             </thead>
            </table>
            <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth">

            <thead>
            <tr>
            <th style="width:50px"></th>
               <th>{"商品ID"}</th><th>{"商品名称"}</th>
               <th onclick={ctx.link().callback(|_| Msg::Sort())}>
               {"商品价格"}
               <img src={sort_svg(self.is_desc)} style="width:20px;height:20px"/>
                 </th>
            </tr>
            </thead>
             <tbody>
                {for self.prods.iter().map(|p:&ProdModel|{
                         self.render_prod(p, ctx.link())
                })}
                </tbody>
                </table>

            </div>

        }
    }
}
impl ProdList {
    fn render_prod(&self, p: &ProdModel, link: &Scope<Self>) -> Html {
        let get_id = p.pid;
        html! {
            <tr class={row_class(get_id,&self).to_string()}  >
              <td>
              <input type="checkbox"
                onclick={link.callback( move |_| Msg::Select(get_id))}
                 checked={
                      if self.rows.contains(&Some(get_id)) {
                          true
                      }else{
                          false
                      }
                 }
              />
              </td>
              <td>{ if p.pid>0 {
                  p.pid.to_string()
              }else{
                  String::from("-")
              }}</td>
              <td onclick={link.callback( move |_| Msg::Edit(get_id))}>
               {
                   if self.edit_info.0==get_id{
                       html!{
                           <input type="text"
                           oninput={link.callback(|e:InputEvent| Msg::EditCell(e.target_unchecked_into::<HtmlInputElement>().value()))}
                           class="input" value={p.pname.to_string()}/>
                       }
                   }else{
                    html!{
                       p.pname.to_string()
                    }
                   }
               }
              </td>
              <td> {p.price} </td>
            </tr>
        }
    }
}

fn sort_svg(isdesc: bool) -> &'static str {
    if isdesc {
        "images/s1.svg"
    } else {
        "images/s2.svg"
    }
}

fn row_class(id: i32, p: &ProdList) -> String {
    let mut classes = String::new();
    if p.rows.contains(&Some(id)) {
        classes.push_str("selected ")
    }
    if p.edit_cells.contains(&Some(id)) {
        classes.push_str("edited ")
    }
    classes
}
