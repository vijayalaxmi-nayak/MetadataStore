# frozen_string_literal: true
module Api
  module V1
    class MediasController < AccountsController
      require 'csv'
      require 'iconv'
      require 'open-uri'

      # displays the medias based on filters
      api :GET, '/medias/', 'Displays medias based on filters'
      param :asset_id, String, desc: 'Asset Id'
      param :title, String, desc: 'Title of the media'
      param :duration, :number, desc: 'Duration of the media in milliseconds'
      param :from, :number, desc: 'Start duration of media in milliseconds'
      param :to, :number, desc: 'End duration of media in milliseconds'
      example %(
      Search by asset_id
      GET api/v1/medias?asset_id=AB100
      {
      "status": "SUCCESS",
      "message": "Loaded medias",
      "data": [
      {
        "asset_id": "AB100",
        "media_type": "audio",
        "account_id": 2,
        "title": null,
        "duration": null,
        "location": null,
        "recorded_time": null,
        "timecode": null,
        "created_at": "2020-02-28T09:12:47.000Z",
        "updated_at": "2020-02-28T09:12:47.000Z"
      }
      ]
      }

      Search by title
      GET api/v1/medias/?title=song4
      {
      "status": "SUCCESS",
      "message": "Loaded medias",
      "data": [
      {
        "asset_id": "AA100",
        "media_type": "audio",
        "account_id": 1,
        "title": "song4",
        "duration": 60,
        "location": "https://www.youtube.com/watch?v=pPy0GQJLZUM",
        "recorded_time": "0001-02-20T01:11:08.000Z",
        "timecode": "00:00:00.60",
        "created_at": "2020-02-28T09:12:39.000Z",
        "updated_at": "2020-02-28T09:13:03.000Z"
      }
      ]
      }

      Search by duration
      GET api/v1/medias?duration=12090
      {
      "status": "SUCCESS",
      "message": "Loaded medias",
      "data": [
      {
        "asset_id": "Z100",
        "media_type": "video",
        "account_id": 1,
        "title": "song3",
        "duration": 12000,
        "location": "https://www.youtube.com/watch?v=pPy0GQJLZUM",
        "recorded_time": "0001-01-20T11:00:08.000Z",
        "timecode": "00:00:12:00",
        "created_at": "2020-02-28T08:56:41.000Z",
        "updated_at": "2020-02-28T09:07:20.000Z"
      },
      {
        "asset_id": "AA100",
        "media_type": "audio",
        "account_id": 1,
        "title": "song4",
        "duration": 60,
        "location": "https://www.youtube.com/watch?v=pPy0GQJLZUM",
        "recorded_time": "0001-02-20T01:11:08.000Z",
        "timecode": "00:00:00.60",
        "created_at": "2020-02-28T09:12:39.000Z",
        "updated_at": "2020-02-28T09:13:03.000Z"
      }
      ]
      }

      Search by asset_id, title, from and to of duration, and offset
      GET api/v1/medias?title=SONG&asset_id=a&from=45&to=100&offset=2
      {
      "status": "SUCCESS",
      "message": "Loaded medias",
      "data": [
      {
        "asset_id": "AO100",
        "media_type": "audio",
        "account_id": 1,
        "title": "song1",
        "duration": 63,
        "location": "https://www.youtube.com/watch?v=QojnRc7SS9o",
        "recorded_time": "0001-02-20T03:10:40.000Z",
        "timecode": "00:00:00.63",
        "created_at": "2020-03-04T09:07:17.000Z",
        "updated_at": "2020-03-05T05:44:33.000Z"
      },
      {
        "asset_id": "AP100",
        "media_type": "audio",
        "account_id": 1,
        "title": "song3",
        "duration": 79,
        "location": "https://www.youtube.com/watch?v=pPy0GQJLZUM",
        "recorded_time": "0001-01-20T11:00:08.000Z",
        "timecode": "00:00:00.79",
        "created_at": "2020-03-04T09:07:21.000Z",
        "updated_at": "2020-03-05T05:44:33.000Z"
      }
      ]
      }
      )
      def index
        medias = Media.where(nil)
        # search by asset_id
        medias = medias.search_by_asset_id(params[:asset_id]) if
params[:asset_id].present?
        # search by title
        medias = medias.search_by_title(params[:title]) if
params[:title].present?
        # search by duration
        medias = medias.search_by_duration(params[:duration]) if
params[:duration].present?
        # search by duration - from and to
        medias = medias.search_by_duration_from_and_to(params[:from], params[:to]) if params[:from].present? and params[:to].present?
        # sort by created_at
        medias = medias.order('created_at')
        # applying limit and offset
        # limit = 10
        # default offset is 0
        offset = params[:offset] if params[:offset].present?
        medias = medias.offset(offset).limit(10)
        if medias == []
          render json: { status: 'NOT FOUND', message: 
'Desired media file does not exists' }, status: :ok
        else
          render json: { status: 'SUCCESS', message: 'Loaded medias', data:
medias }, status: :ok
        end
      end

      # creates a new media
      api :POST, '/medias/', 'Creates a new media'
      param :asset_id, String, desc: 'Asset Id', required: true
      param :media_type, String, desc: 'Media Type(Audio or Video)', required:
true
      param :account_id, String, desc: 'Account Id', required: true
      param :title, String, desc: 'Title of the media'
      param :duration, :number, desc: 'Duration of the media in milliseconds'
      param :location, String, desc: 'File location where the media is stored'
      param :recorded_time, String, desc: 'Recorded time of the media'
      example %(
      POST api/v1/medias
      {
      "asset_id":"AH100",
      "media_type":"audio",
      "account_id":"2"
      }

      Server response:
      {
      "status": "SUCCESS",
      "message": "saved audio",
      "data": {
        "asset_id": "AH100",
        "media_type": "audio",
        "account_id": 2,
        "title": null,
        "duration": 0,
        "location": null,
        "recorded_time": null,
        "timecode": null,
        "created_at": "2020-03-02T11:27:56.000Z",
        "updated_at": "2020-03-02T11:27:56.000Z"
      }
      }
      )
      def create
        media = Media.new(params_media)
        if media.save
          if media.media_type == 'audio'
            render json: { status: 'SUCCESS', message: 'saved audio', data:
media }, status: :ok
          else
            render json: { status: 'SUCCESS', message: 'saved video', data:
media }, status: :ok
          end
        else
          render json: { status: 'ERROR', message: 'failed to save media', data:
media.errors }, status: :unprocessable_entity
        end
      end

      # shows a specfic media based on asset_id
      api :GET, '/medias/:id', 'Displays a specific media based on asset_id'
      param :id, String, desc: 'Asset Id'
      example %(
      GET api/v1/medias/AA100
      {
      "status": "SUCCESS",
      "message": "Loaded Media",
      "data": {
        "asset_id": "AA100",
        "media_type": "audio",
        "account_id": 1,
        "title": "song4",
        "duration": 60,
        "location": "https://www.youtube.com/watch?v=pPy0GQJLZUM",
        "recorded_time": "0001-02-20T01:11:08.000Z",
        "timecode": "00:00:00.60",
        "created_at": "2020-02-28T09:12:39.000Z",
        "updated_at": "2020-02-28T09:13:03.000Z"
      }
      }
      )
      def show
        media = Media.find_by_asset_id(params[:id])
        if media.nil?
          render json: { status: 'NOT FOUND', message: 
'Desired asset_id of Media does not exists' }, status: :ok
        else
          render json: { status: 'SUCCESS', message: 'Loaded Media', data:
media }, status: :ok
        end
      end

      # deletes a specific media based on asset_id
      api :DELETE, '/medias/:id', 'Deletes a specific media based on asset_id'
      param :asset_id, String, desc: 'Asset Id'
      example %(
      DELETE api/v1/medias/AH100
      {
      "status": "SUCCESS",
      "message": "Deleted media",
      "data": {
        "asset_id": "AH100",
        "media_type": "audio",
        "account_id": 2,
        "title": null,
        "duration": 0,
        "location": null,
        "recorded_time": null,
        "timecode": null,
        "created_at": "2020-03-02T11:27:56.000Z",
        "updated_at": "2020-03-02T11:27:56.000Z"
      }
      }
      )
      def destroy
        del_media = Media.find_by_asset_id(params[:id])
        del_media.destroy
        render json: { status: 'SUCCESS', message: 'Deleted media', data:
del_media }, status: :ok
      end

      # uploads the metadata submitted by user via .csv file
      api :PUT, '/medias/', 'Updates the metadata of media'
      param :asset_id, String, desc: 'Asset Id'
      param :title, String, desc: 'Title of the media'
      param :duration, :number, desc: 'Duration of the media in milliseconds'
      param :location, String, desc: 'File location where the media is stored'
      param :recorded_time, String, desc: 'Recorded time of the media'
      example %(
      PUT api/v1/medias/
      Input:
      {
      "id":"/home/amagi/Desktop/meta.csv"
      }

      Server response:
      {
      "status": "SUCCESS",
      "message": "Loaded metadata",
      "saved_data": [
      {
        "asset_id": "Z100",
        "title": "song3",
        "duration": "12000",
        "location": "https://www.youtube.com/watch?v=pPy0GQJLZUM",
        "recorded_time": "01/01/20 11:00:08",
        "timecode": "00:00:12:00"
      },
      {
        "asset_id": "AA100",
        "title": "song4",
        "duration": "60",
        "location": "https://www.youtube.com/watch?v=pPy0GQJLZUM",
        "recorded_time": "01/02/20 01:11:08",
        "timecode": "00:00:00.60"
      }
      ],
      "unsaved_data": [
      {
        "asset_id": "D100",
        "title": "song1",
        "duration": "12003",
        "location": "https://www.youtube.com/watch?v=QojnRc7SS9o",
        "recorded_time": "01/02/20 03:10:40"
      }
      ]
      }
      )
      def update
        saved = []
        unsaved = []
        # CSV.foreach(params[:id], headers: true) do |row| 
        csv_text = File.open(params[:id])
        csv = CSV.parse(csv_text, :headers => true)
        csv.each do |row|
          # byebug
          print "\n-----------\n"
          print row
          print "\n-----------\n"
          hash_value = row.to_hash
          if Media.exists? asset_id: hash_value['asset_id']
            type = Media.where(asset_id:
hash_value['asset_id']).pluck(:media_type)[0]
            if type == 'audio'
              hash_value['timecode'] =
Audio.duration_tc(hash_value['duration'].to_i)
            elsif type == 'video'
              hash_value['timecode'] =
Video.duration_tc(hash_value['duration'].to_i)
            end
            metadata = Media.find_by_asset_id(hash_value['asset_id'])
            if metadata.update_attributes(hash_value)
              saved.append(hash_value)
            end
          else
            unsaved.append(hash_value)
          end
        end
        render json: { status: 'SUCCESS', message: 'Loaded metadata',
saved_data: saved, unsaved_data: unsaved }, status: :ok
      end

      private

      def params_media
        params.permit(:asset_id, :account_id, :media_type)
      end
    end
  end
end
