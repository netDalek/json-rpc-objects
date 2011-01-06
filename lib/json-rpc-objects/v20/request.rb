# encoding: utf-8
require "yajl/json_gem"
require "hash-utils"
require "multitype-introspection"
require "json-rpc-objects/v11/procedure-call"

module JsonRpcObjects
    module V20
        class Request < JsonRpcObjects::V11::ProcedureCall

            ##
            # Holds JSON-RPC version specification.
            #
            
            VERSION = :"2.0"
            
            ##
            # Holds JSON-RPC version member identification.
            #
            
            VERSION_MEMBER = :jsonrpc
                        
            ##
            # Indicates ID has been set.
            #
            
            @_id_set
        
            ##
            # Parses JSON-RPC string.
            #
            
            def self.parse(string)
                self::new(JSON.load(string))
            end

            ##
            # Creates new one.
            #
            
            def self.create(method, params = [ ], opts = { })
                data = {
                    :method => method,
                    :params => params
                }
                
                data.merge! opts
                return self::new(data)
            end
            
            
            ##
            # Checks correctness of the request data.
            #
            
            def check!
                super()
                
                if not @id.kind_of_any? [String, Integer, NilClass]
                    raise Exception::new("ID must contain String, Number or nil if included.")
                end
            end
                                        
            ##
            # Renders data to output hash.
            #
            
            def output
                result = super()
                
                if @_id_set and @id.nil?
                    result[:id] = nil
                end
                
                return result
            end

            ##
            # Indicates, it's notification.
            #

            def notification?
                not @_id_set
            end
            
           
            
            protected
            
            ##
            # Assigns request data.
            #

            def data=(value, mode = nil)
                data = __convert_data(value, mode)
                
                # Indicates, ID has been explicitly assigned
                @_id_set = data.include? :id
                
                super(data, :converted)
            end            
            
        end
    end
end
