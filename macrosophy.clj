(def dribble-raw (slurp  "/misc/moi/Dropbox/d/emacs-dribble"))

(def key-re #"\<(.*?)\>")

(defn re-find-all
  "Find all matches in a string."
  [re s]
  (let [m (re-matcher re s)
        collector (atom [])]
    (while (.find m)
      (swap! collector conj (re-groups m)))
    @collector))

(defn parse-dribble
  "Turn dribble file into a list of characters and keywords, each representing a keypress"
  [s]
  (flatten
   (interleave (map #(into () %) (clojure.string/split s key-re))
               (map (comp keyword second)
                    (re-find-all key-re s)))))

;;; → utils
(defn safe-inc
  "inc that interprets nil as 0."
  [x]
  (if x (inc x) 1))

;;; → utils
(defn count-substrings
  [s [lower upper]]
  (loop [s s
         acc {}]
    (let [counts (count s)]
      (if (< counts lower)
        acc
        (recur (rest s)
               (loop [i upper
                      acc acc]
                 (if (< i lower)
                   acc
                   (recur (- i 1) (if (< i counts) 
                                    (update acc (into [] (take i s)) safe-inc)
                                    acc)))))))))

;;; → utils, one there is less general than this
(defn sort-map-by-values [m]
  (into (sorted-map-by (fn [k1 k2] (compare (get m k2) (get m k1)))) m))


(defn all-the-same? [vec]
  (some)


(def results
  (-> dribble-raw
      parse-dribble
      (count-substrings [4 12])
      sort-map-by-values))
