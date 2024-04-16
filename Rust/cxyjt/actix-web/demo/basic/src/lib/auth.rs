use std::future::{ready, Ready};

use actix_web::{
    body::EitherBody,
    dev::{forward_ready, Service, ServiceRequest, ServiceResponse, Transform},
    Error, HttpResponse, error::HttpError,
};
use actix_web::http::header::{HeaderName,HeaderValue};
 
pub struct Auth;
 
impl<S, B> Transform<S, ServiceRequest> for Auth
where
    S: Service<ServiceRequest, Response = ServiceResponse<B>, Error = Error>,
    S::Future: 'static,
    B: 'static,
{
    type Response = ServiceResponse<EitherBody<B>>;
    type Error = Error;
    type InitError = ();
    type Transform = AuthService<S>;
    type Future = Ready<Result<Self::Transform, Self::InitError>>;

    fn new_transform(&self, service: S) -> Self::Future {

        ready(Ok(AuthService { service }))
    }
}
 
use std::pin::Pin;
use std::future::Future;
pub struct AuthService<S> {
    service: S,
}
 
impl<S, B> Service<ServiceRequest> for AuthService<S>
where
    S: Service<ServiceRequest, Response = ServiceResponse<B>, Error = Error>,
    S::Future: 'static,
    B: 'static,
{
    type Response = ServiceResponse<EitherBody<B>>;
    type Error = Error;
    type Future = Pin<Box<dyn Future<Output = Result<Self::Response,Self::Error>>+>>;
    
    forward_ready!(service);

    fn call(&self, req: ServiceRequest) -> Self::Future {
          let get_path=req.path();
          if get_path=="/admin"{

            //let http_res=HttpResponse::Unauthorized().body("My Unauthorized");
            //let http_req=req.request().to_owned();
            return Box::pin(async move{
               Err(actix_web::error::ErrorUnauthorized("Unauthorized"))
            // Ok(ServiceResponse::new(http_req, http_res).map_into_right_body())
               
            });

          }
// 正确 逻辑
          let fut = self.service.call(req);
          Box::pin(async move {
              let    res = fut.await?;
              
              Ok(res.map_into_left_body())
          })
       
    }
}