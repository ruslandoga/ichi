defmodule ITest do
  use ExUnit.Case, async: true

  # https://readevalprint.tumblr.com/post/97467849358/who-needs-graph-theory-anyway
  # but adapted for immutability (TODO)
  def find_substring_words(str) do
    len = String.length(str)

    segments =
      for from <- 0..(len - 1), to <- (from + 1)..len do
        word = String.slice(str, from..(to - 1))

        # maybe
        # {
        #   _position = {from, to},
        #   _static = %{word: word, score: score},
        #   _dynamic = %{accum: 0, path: []}
        # }

        {{from, to}, %{word: word, score: get_score(word), accum: 0, path: []}}
      end

    positions = Enum.map(segments, fn {position, _} -> position end)
    segments = Map.new(segments)
    {positions, segments}
  end

  def find_word(_str) do
  end

  def get_score(_str) do
    # TODO
    0
  end

  # (let ((best-accum 0) (best-path nil))
  #   (loop for (seg1 . rest) on segments
  #      when (> (segment-score seg1) (segment-accum seg1))
  #        do (setf (segment-accum seg1) (segment-score seg1)
  #                 (segment-path seg1) (list seg1))
  #           (when (> (segment-accum seg1) best-accum)
  #             (setf best-accum (segment-accum seg1)
  #                   best-path (segment-path seg1)))
  #      when (> (segment-score seg1) 0)
  #        do (loop for seg2 in rest
  #              if (>= (segment-start seg2) (segment-end seg1))
  #              do (let ((accum (+ (segment-accum seg1) (segment-score seg2))))
  #                   (when (> accum (segment-accum seg2))
  #                     (setf (segment-accum seg2) accum
  #                           (segment-path seg2) (cons seg2 (segment-path seg1)))
  #                     (when (> accum best-accum)
  #                       (setf best-accum accum
  #                             best-path (segment-path seg2)))))))

  def find_best_path(positions, segments) do
    # (let ((best-accum 0) (best-path nil))
    find_best_path(positions, segments, _best_accum = 0, _best_path = [])
  end

  #   (loop for (seg1 . rest) on segments
  defp find_best_path([pos1 | positions], segments, best_accum, best_path) do
    seg1 = segments[pos1]

    cond do
      #      when (> (segment-score seg1) (segment-accum seg1))
      seg1.score > seg1.accum ->
        #        do (setf (segment-accum seg1) (segment-score seg1)
        #                 (segment-path seg1) (list seg1))
        seg1 = %{seg1 | accum: seg1.score, path: [pos1]}
        segments = Map.put(segments, pos1, seg1)

        #           (when (> (segment-accum seg1) best-accum)
        if seg1.accum > best_accum do
          #             (setf best-accum (segment-accum seg1)
          #                   best-path (segment-path seg1)))
          find_best_path(positions, segments, seg1.accum, seg1.path)
        else
          find_best_path(positions, segments, best_accum, best_path)
        end

      #      when (> (segment-score seg1) 0)
      seg1.score > 0 ->
        {segments, best_accum, best_path} =
          find_best_path_ahead(positions, segments, pos1, seg1, best_accum, best_path)

        find_best_path(positions, segments, best_accum, best_path)

      true ->
        find_best_path(positions, segments, best_accum, best_path)
    end
  end

  defp find_best_path([], segments, best_accum, best_path) do
    {segments, best_accum, :lists.reverse(best_path)}
  end

  #        do (loop for seg2 in rest
  defp find_best_path_ahead([pos2 | positions], segments, pos1, seg1, best_accum, best_path) do
    seg2 = segments[pos2]
    #              do (let ((accum (+ (segment-accum seg1) (segment-score seg2))))
    accum = seg1.accum + seg2.score

    #                   (when (> accum (segment-accum seg2))
    if accum > seg2.accum do
      #                     (setf (segment-accum seg2) accum
      #                           (segment-path seg2) (cons seg2 (segment-path seg1)))
      seg2 = %{seg2 | accum: accum, path: seg2.path ++ seg1.path}
      segments = Map.put(segments, pos2, seg2)

      #                     (when (> accum best-accum)
      if accum > best_accum do
        #                       (setf best-accum accum
        #                             best-path (segment-path seg2)))))))
        find_best_path_ahead(positions, segments, pos1, seg1, accum, seg2.path)
      else
        find_best_path_ahead(positions, segments, pos1, seg1, best_accum, best_path)
      end
    else
      find_best_path_ahead(positions, segments, pos1, seg1, best_accum, best_path)
    end
  end

  defp find_best_path_ahead([], segments, _pos1, _seg1, best_accum, best_path) do
    {segments, best_accum, best_path}
  end

  test "find_substring_words/1" do
    assert find_substring_words("abcd") ==
             {[{0, 1}, {0, 2}, {0, 3}, {0, 4}, {1, 2}, {1, 3}, {1, 4}, {2, 3}, {2, 4}, {3, 4}],
              %{
                {0, 1} => %{accum: 0, path: [], score: 0, word: "a"},
                {0, 2} => %{accum: 0, path: [], score: 0, word: "ab"},
                {0, 3} => %{accum: 0, path: [], score: 0, word: "abc"},
                {0, 4} => %{accum: 0, path: [], score: 0, word: "abcd"},
                {1, 2} => %{accum: 0, path: [], score: 0, word: "b"},
                {1, 3} => %{accum: 0, path: [], score: 0, word: "bc"},
                {1, 4} => %{accum: 0, path: [], score: 0, word: "bcd"},
                {2, 3} => %{accum: 0, path: [], score: 0, word: "c"},
                {2, 4} => %{accum: 0, path: [], score: 0, word: "cd"},
                {3, 4} => %{accum: 0, path: [], score: 0, word: "d"}
              }}

    assert find_substring_words("日本語の") ==
             {[{0, 1}, {0, 2}, {0, 3}, {0, 4}, {1, 2}, {1, 3}, {1, 4}, {2, 3}, {2, 4}, {3, 4}],
              %{
                {0, 1} => %{accum: 0, path: [], score: 0, word: "日"},
                {0, 2} => %{accum: 0, path: [], score: 0, word: "日本"},
                {0, 3} => %{accum: 0, path: [], score: 0, word: "日本語"},
                {0, 4} => %{accum: 0, path: [], score: 0, word: "日本語の"},
                {1, 2} => %{accum: 0, path: [], score: 0, word: "本"},
                {1, 3} => %{accum: 0, path: [], score: 0, word: "本語"},
                {1, 4} => %{accum: 0, path: [], score: 0, word: "本語の"},
                {2, 3} => %{accum: 0, path: [], score: 0, word: "語"},
                {2, 4} => %{accum: 0, path: [], score: 0, word: "語の"},
                {3, 4} => %{accum: 0, path: [], score: 0, word: "の"}
              }}
  end

  test "find_best_path/1" do
    assert find_best_path(
             [
               {0, 1},
               {0, 2},
               {1, 2}
             ],
             %{
               {0, 1} => %{accum: 0, path: [], score: 1, word: "a"},
               {0, 2} => %{accum: 0, path: [], score: 2, word: "ab"},
               {1, 2} => %{accum: 0, path: [], score: 1, word: "b"}
             }
           ) ==
             {
               _segments = %{
                 {0, 1} => %{accum: 1, path: [{0, 1}], score: 1, word: "a"},
                 {0, 2} => %{accum: 2, path: [{0, 2}], score: 2, word: "ab"},
                 {1, 2} => %{accum: 1, path: [{1, 2}], score: 1, word: "b"}
               },
               _best_accum = 2,
               _best_path = [{0, 2}]
             }
  end
end
