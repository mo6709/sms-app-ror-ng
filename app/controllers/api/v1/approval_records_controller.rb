module Api
    module V1
        class ApprovalRecordsController < ApplicationController
            # make sure it dose not need autherization
            # make the index retun json
            # return https status
            # get data from body for POST requests
            # get data from query params
            # redirect with to different route

            # errors handeling

            skip_before_action :authenticate_user!
            def index
                manager_id = request.query_parameters[:manager_id]
                manger_role = request.query_parameters[:manager_role]

                render json: { 
                    message: "i am at index ApprovalRecordsController",
                    manager_id: manager_id || "not given",
                    manger_role: manger_role || "not given"
                }, status: 200
            end

            def create
                user_ids = 
                manager_id = params[:manager_id]
                notes = 
                status
                # render json: { message: "at the POST method. the user_ids:#{user_ids}" }, status: :ok
                # render json: 
                # {   
                #     method: request.method,
                #     url: request.url,
                #     path: request.path,
                #     params: request.params,
                #     headers: request.headers.to_h.select { |k, _| k.start_with?('HTTP_') },
                #     body: request.body.read,
                #     content_type: request.content_type,
                #     remote_ip: request.remote_ip
                # }.to_json

                begin# Get parameters from request body
                    approval_params = params.require(:approval_record).permit(
                        :user_id,
                        :manager_id,
                        :status,
                        :notes
                    )

                    approval_record = ApprovalRecord.new(approval_params)
                    if approval_record.save
                        render json: { message: "created new record for approval", approval_record: approval_record }, status: :created
                    else
                        render json: { error: approval_record.errors.full_messages }, status: :unprocessable_entity
                    end
                rescue Mongoid::Errors::DocumentNotFound => e
                    render json: { error: "not found" }, status: :not_found
                rescue ActionController::ParameterMissing => e
                    render json: { error: "bad request" }, status: :bad_request
                end
            end
        end
    end
end