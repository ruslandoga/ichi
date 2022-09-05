defmodule I do
  import Ecto.Query

  # # https://github.com/tshatrov/ichiran/blob/6b49ca76b7777de1446d03b5fa7b27880d1554b5/dict-errata.lisp#L3-L15
  # def find_conf(seq_from, options) do
  #   [conj_type, pos, neg, fml] = options

  #   "conjugation"
  #   |> where(from: ^seq_from)
  #   |> join(:inner, [c], cp in "conj_prop", on: c.id == cp.conj_id)
  #   |> where([c, cp], cp.conj_type == ^conj_type)
  #   |> where([c, cp], cp.pos == ^pos)
  #   |> where([c, cp], cp.neg == ^neg)
  #   |> where([c, cp], cp.fml == ^fml)
  #   |> select([c], c.id)
  # end

  # def get_all_readings(seq) do
  #   kanji_q = "kanji_text" |> where(seq: ^seq) |> select([k], k.text)
  #   kana_q = "kana_text" |> where(seq: ^seq) |> select([k], k.text)
  #   kanji_q |> union(^kana_q) |> Repo.all()
  # end

  # # TODO errata
  # #  https://github.com/tshatrov/ichiran/blob/6b49ca76b7777de1446d03b5fa7b27880d1554b5/dict-errata.lisp#L277

  # # https://github.com/tshatrov/ichiran/blob/6b49ca76b7777de1446d03b5fa7b27880d1554b5/dict.lisp#L1441-L1444
  # def dict_segment(str, limit \\ 5) do
  #   joined_str = join_substring_words(str)

  #   for {path, score} <- find_best_path(joined_str, lenght(str), limit) do
  #     {fill_segment_path(str, path), score}
  #   end
  # end

  # def join_substring_words(str) do
  #   {result, kanji_break} = _join_substring_words(str)
  # end

  # # https://github.com/tshatrov/ichiran/blob/6b49ca76b7777de1446d03b5fa7b27880d1554b5/dict.lisp#L1064
  # defp _join_subsctring_words(str) do
  #   sticky = find_sticky_positions(str)
  #   substring_hash = find_substring_words(str, sticky: sticky)
  #   katakana_groups = consecutive_char_groups(katakana: str)
  # end
end
