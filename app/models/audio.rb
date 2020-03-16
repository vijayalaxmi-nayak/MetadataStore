# frozen_string_literal: true
class Audio < Media
  # duration_tc() method converts the duration given in milliseconds to timecode
  # in milliseconds
  def self.duration_tc(duration)
    milliseconds = (duration % 1000)
    seconds = (duration / 1000) % 60
    minutes = (duration / (1000 * 60)) % 60
    hours = (duration / (1000 * 60 * 60)) % 24
    hours = hours < 10 ? '0' + hours.to_s : hours.to_s
    minutes = minutes < 10 ? '0' + minutes.to_s : minutes.to_s
    seconds = seconds < 10 ? '0' + seconds.to_s : seconds.to_s
    hours.to_s + ':' + minutes.to_s + ':' + seconds.to_s + '.' + 
milliseconds.to_s
  end
end
