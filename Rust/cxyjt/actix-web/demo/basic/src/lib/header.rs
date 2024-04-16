use std::future::{ready, Ready};

use actix_web::{
    dev::{forward_ready, Service, ServiceRequest, ServiceResponse, Transform},
    Error,
};
 
pub struct AddHeader;
 
impl<S, B> Transform<S, ServiceRequest> for AddHeader
where
    S: Service<ServiceRequest, Response = ServiceResponse<B>, Error = Error>,
    S::Future: 'static,
    B: 'static,
{
    type Response = ServiceResponse<B>;
    type Error = Error;
    type InitError = ();
    type Transform = AddHeaderService<S>;
    type Future = Ready<Result<Self::Transform, Self::InitError>>;

    fn new_transform(&self, service: S) -> Self::Future {
        ready(Ok(AddHeaderService { service }))
    }
}
use std::future::Future;
use std::pin::Pin;
use actix_web::http::header::{HeaderName,HeaderValue};
pub struct AddHeaderService<S> {
    service: S,
}

impl<S, B> Service<ServiceRequest> for AddHeaderService<S>
where
    S: Service<ServiceRequest, Response = ServiceResponse<B>, Error = Error>,
    S::Future: 'static,
    B: 'static,
{
    type Response = ServiceResponse<B>;
    type Error = Error;
    type Future = Pin<Box<dyn Future<Output = Result<Self::Response,Self::Error>>>>;

    forward_ready!(service);

    fn call(&self, req: ServiceRequest) -> Self::Future {
        let fut = self.service.call(req);
        Box::pin(async move {
            let mut  res = fut.await?;
            res.headers_mut().insert(HeaderName::from_static("myage"),
            HeaderValue::from_static("19"));
        
            Ok(res)
        })
    }
}