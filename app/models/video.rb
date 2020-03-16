# frozen_string_literal: true
class Video < Media
  # duration_tc() method converts the duration given in milliseconds to timecode
  # in frames
  def self.duration_tc(duration)
    seconds = (duration / 1000) % 60
    # Assume that there are 60 frames per second
    # 1 frame = 50 / 3 milliseconds
    frames = ((duration - (seconds * 1000)) * 3 / 50).round
    minutes = (duration / (1000 * 60)) % 60
    hours = (duration / (1000 * 60 * 60)) % 24
    hours = hours < 10 ? '0' + hours.to_s : hours.to_s
    minutes = minutes < 10 ? '0' + minutes.to_s : minutes.to_s
    seconds = seconds < 10 ? '0' + seconds.to_s : seconds.to_s
    frames = frames < 10 ? '0' + frames.to_s : frames.to_s
    hours.to_s + ':' + minutes.to_s + ':' + seconds.to_s + ':' +
frames.to_s
  end
end
