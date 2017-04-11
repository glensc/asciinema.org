(ns asciinema.component.a2png
  (:require [asciinema.boundary.png-generator :as png-generator]
            [asciinema.util.io :refer [cleanup-input-stream create-tmp-dir]]
            [clojure.java
             [io :as io]
             [shell :as shell]]))

(defn- exec-a2png [bin-path in-url out-path {:keys [snapshot-at theme scale]}]
  (let [{:keys [exit] :as result} (shell/sh bin-path
                                            in-url
                                            out-path
                                            (str snapshot-at)
                                            theme
                                            (str scale))]
    (when-not (zero? exit)
      (throw (ex-info "a2png error" result)))))

(defrecord A2png [bin-path]
  png-generator/PngGenerator
  (generate [this json-is png-params]
    (let [dir (create-tmp-dir "a2png-")
          cleanup #(shell/sh "rm" "-rf" (.getPath dir))
          json-local-path (str dir "/asciicast.json")
          png-local-path (str dir "/asciicast.png")]
      (io/copy json-is (io/file json-local-path))
      (exec-a2png bin-path json-local-path png-local-path png-params)
      (cleanup-input-stream (io/input-stream png-local-path) cleanup))))

(defn a2png [{:keys [bin-path]}]
  (->A2png bin-path))
