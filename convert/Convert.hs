{-# LANGUAGE OverloadedStrings #-}

import           Control.Lens
import           Control.Monad
import           Data.Monoid
import qualified Data.Text as T
import qualified Data.Text.IO as T
import           Text.XML
import           Text.XML.Lens
import           System.IO

main = do
    doc <- Text.XML.readFile
               (def { psDecodeEntities   = decodeHtmlEntities
                    , psRetainNamespaces = True })
               "whatthoughtsmaycome.wordpress.2016-07-19.xml"
    let items = doc ^.. root . el "rss" ./ el "channel" ./ el "item"
    forM_ items $ \item -> do
        let postId   = item ^. id ./ named "post_id"   . text
        let title    = item ^. id ./ el "title"        . text
        let category = item ^. id ./ el "category"     . text
        let content  = item ^. id ./ named "encoded"   . text
        let pubDate  = item ^. id ./ el "pubDate"      . text
        let postDate = item ^. id ./ named "post_date" . text
        let postName = item ^. id ./ named "post_name" . text
        let (date, time) = T.splitAt 10 postDate
        let fileName = "posts/" <> date <> "-" <> postName <> ".md"
        withFile (T.unpack fileName) WriteMode $ \h -> do
            T.hPutStrLn h $ "---"
            T.hPutStrLn h $ "id: " <> postId
            T.hPutStrLn h $ "title: " <> title
            T.hPutStrLn h $ "date: " <> pubDate
            T.hPutStrLn h $ "category: " <> category
            T.hPutStrLn h $ "---"
            T.hPutStrLn h ""
            T.hPutStrLn h content
