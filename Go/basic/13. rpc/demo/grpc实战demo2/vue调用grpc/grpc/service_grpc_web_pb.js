/**
 * @fileoverview gRPC-Web generated client stub for 
 * @enhanceable
 * @public
 */

// GENERATED CODE -- DO NOT EDIT!


/* eslint-disable */
// @ts-nocheck



const grpc = {};
grpc.web = require('grpc-web');


var models_pb = require('./models_pb.js')
const proto = require('./service_pb.js');

/**
 * @param {string} hostname
 * @param {?Object} credentials
 * @param {?Object} options
 * @constructor
 * @struct
 * @final
 */
proto.ProdServiceClient =
    function(hostname, credentials, options) {
  if (!options) options = {};
  options['format'] = 'text';

  /**
   * @private @const {!grpc.web.GrpcWebClientBase} The client
   */
  this.client_ = new grpc.web.GrpcWebClientBase(options);

  /**
   * @private @const {string} The hostname
   */
  this.hostname_ = hostname;

};


/**
 * @param {string} hostname
 * @param {?Object} credentials
 * @param {?Object} options
 * @constructor
 * @struct
 * @final
 */
proto.ProdServicePromiseClient =
    function(hostname, credentials, options) {
  if (!options) options = {};
  options['format'] = 'text';

  /**
   * @private @const {!grpc.web.GrpcWebClientBase} The client
   */
  this.client_ = new grpc.web.GrpcWebClientBase(options);

  /**
   * @private @const {string} The hostname
   */
  this.hostname_ = hostname;

};


/**
 * @const
 * @type {!grpc.web.MethodDescriptor<
 *   !proto.ProdRequest,
 *   !proto.ProdResponse>}
 */
const methodDescriptor_ProdService_GetProd = new grpc.web.MethodDescriptor(
  '/ProdService/GetProd',
  grpc.web.MethodType.UNARY,
  models_pb.ProdRequest,
  models_pb.ProdResponse,
  /**
   * @param {!proto.ProdRequest} request
   * @return {!Uint8Array}
   */
  function(request) {
    return request.serializeBinary();
  },
  models_pb.ProdResponse.deserializeBinary
);


/**
 * @const
 * @type {!grpc.web.AbstractClientBase.MethodInfo<
 *   !proto.ProdRequest,
 *   !proto.ProdResponse>}
 */
const methodInfo_ProdService_GetProd = new grpc.web.AbstractClientBase.MethodInfo(
  models_pb.ProdResponse,
  /**
   * @param {!proto.ProdRequest} request
   * @return {!Uint8Array}
   */
  function(request) {
    return request.serializeBinary();
  },
  models_pb.ProdResponse.deserializeBinary
);


/**
 * @param {!proto.ProdRequest} request The
 *     request proto
 * @param {?Object<string, string>} metadata User defined
 *     call metadata
 * @param {function(?grpc.web.Error, ?proto.ProdResponse)}
 *     callback The callback function(error, response)
 * @return {!grpc.web.ClientReadableStream<!proto.ProdResponse>|undefined}
 *     The XHR Node Readable Stream
 */
proto.ProdServiceClient.prototype.getProd =
    function(request, metadata, callback) {
  return this.client_.rpcCall(this.hostname_ +
      '/ProdService/GetProd',
      request,
      metadata || {},
      methodDescriptor_ProdService_GetProd,
      callback);
};


/**
 * @param {!proto.ProdRequest} request The
 *     request proto
 * @param {?Object<string, string>} metadata User defined
 *     call metadata
 * @return {!Promise<!proto.ProdResponse>}
 *     Promise that resolves to the response
 */
proto.ProdServicePromiseClient.prototype.getProd =
    function(request, metadata) {
  return this.client_.unaryCall(this.hostname_ +
      '/ProdService/GetProd',
      request,
      metadata || {},
      methodDescriptor_ProdService_GetProd);
};


/**
 * @const
 * @type {!grpc.web.MethodDescriptor<
 *   !proto.ProdRequest,
 *   !proto.ProdResponse>}
 */
const methodDescriptor_ProdService_GetProd2 = new grpc.web.MethodDescriptor(
  '/ProdService/GetProd2',
  grpc.web.MethodType.UNARY,
  models_pb.ProdRequest,
  models_pb.ProdResponse,
  /**
   * @param {!proto.ProdRequest} request
   * @return {!Uint8Array}
   */
  function(request) {
    return request.serializeBinary();
  },
  models_pb.ProdResponse.deserializeBinary
);


/**
 * @const
 * @type {!grpc.web.AbstractClientBase.MethodInfo<
 *   !proto.ProdRequest,
 *   !proto.ProdResponse>}
 */
const methodInfo_ProdService_GetProd2 = new grpc.web.AbstractClientBase.MethodInfo(
  models_pb.ProdResponse,
  /**
   * @param {!proto.ProdRequest} request
   * @return {!Uint8Array}
   */
  function(request) {
    return request.serializeBinary();
  },
  models_pb.ProdResponse.deserializeBinary
);


/**
 * @param {!proto.ProdRequest} request The
 *     request proto
 * @param {?Object<string, string>} metadata User defined
 *     call metadata
 * @param {function(?grpc.web.Error, ?proto.ProdResponse)}
 *     callback The callback function(error, response)
 * @return {!grpc.web.ClientReadableStream<!proto.ProdResponse>|undefined}
 *     The XHR Node Readable Stream
 */
proto.ProdServiceClient.prototype.getProd2 =
    function(request, metadata, callback) {
  return this.client_.rpcCall(this.hostname_ +
      '/ProdService/GetProd2',
      request,
      metadata || {},
      methodDescriptor_ProdService_GetProd2,
      callback);
};


/**
 * @param {!proto.ProdRequest} request The
 *     request proto
 * @param {?Object<string, string>} metadata User defined
 *     call metadata
 * @return {!Promise<!proto.ProdResponse>}
 *     Promise that resolves to the response
 */
proto.ProdServicePromiseClient.prototype.getProd2 =
    function(request, metadata) {
  return this.client_.unaryCall(this.hostname_ +
      '/ProdService/GetProd2',
      request,
      metadata || {},
      methodDescriptor_ProdService_GetProd2);
};


module.exports = proto;

