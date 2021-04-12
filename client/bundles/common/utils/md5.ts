import SparkMD5 from 'spark-md5';

export function calculateMD5(file: File): Promise<any> {
  return new Promise((resolve, reject) => {
    let blobSlice = File.prototype.slice || File.prototype.mozSlice || File.prototype.webkitSlice,
    chunkSize = 2097152, // read in chunks of 2MB
    chunks = Math.ceil(file.size / chunkSize),
    currentChunk = 0,
    spark = new SparkMD5.ArrayBuffer(),
    frOnload = function(e){
      spark.append(e.target.result); // append array buffer
      currentChunk++;
      if (currentChunk < chunks) {
        loadNext();
      } else {
        resolve(spark.end(true));
      }
    },
    frOnerror = function () {
      reject();
    };
    function loadNext() {
      const fileReader = new FileReader();
      fileReader.onload = frOnload;
      fileReader.onerror = frOnerror;
      let start = currentChunk * chunkSize,
        end = ((start + chunkSize) >= file.size) ? file.size : start + chunkSize;
      fileReader.readAsArrayBuffer(blobSlice.call(file, start, end));
    };

    loadNext();
  });
};
