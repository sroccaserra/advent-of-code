(ns advent-of-code-2019.day-03.path
  (:require [clojure.string :as str]
            [clojure.edn :as edn]))

(def ^{:private true} moves {'U [identity inc]
                             'D [identity dec]
                             'L [dec identity]
                             'R [inc identity]})

(def start-position '([0 0]))

(defn parse-command [command]
  (->> (str/split command #"")
    (map edn/read-string)))

(defn- apply-move [move path]
  (let [[position] path
        new-position (map #(%1 %2) move position)]
    (conj path new-position)))

(defn eval-command [command path]
  (let [[direction nb-steps] command
        [[x y]] path
        move (direction moves)]
    (nth (iterate (partial apply-move move) path)
         nb-steps)))

(defn compute-path [commands]
  (loop [remaining-commands commands
         result start-position]
    (if (empty? remaining-commands)
      result
      (recur (drop 2 remaining-commands)
             (eval-command (take 2 remaining-commands) result)))))
