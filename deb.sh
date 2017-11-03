#!/usr/bin/zsh

clone() {
  git clone $repo
}

make_all_the_things() {
  directories=('pe-parse' 'PicoSHA2' 'spii')

  for dr in $directories; do
    cd $dr
    cmake ./CMakeLists.txt
    make -j5
    cd ..
  done
  cd ..
  make -j5
  sudo make install
}

clone_all_the_things() {
  repos=('https://github.com/okdshin/PicoSHA2.git' 'https://github.com/trailofbits/pe-parse.git' 'https://github.com/PetterS/spii.git')
  for repo in $repos; do
    clone $repo
  done


}


build_dep() {
  sudo apt-get install cmake libeigen3-dev libboost-all-dev zlib1g-dev libelf-dev libgtest-dev
  if [ ! -d third_party ]; then
    mkdir third_party 
  fi

  cd third_party
  wget https://github.com/google/googletest/archive/release-1.7.0.tar.gz
  tar xf release-1.7.0.tar.gz
  cd googletest-release-1.7.0
  cmake -DBUILD_SHARED_LIBS=ON .
  make -j5
  sudo cp -a include/gtest /usr/include
  sudo cp -a libgtest_main.so libgtest.so /usr/lib/
  sudo cp -a libgtest.so libgtest.so /usr/lib/
}

build_dyninst() { 
  cd ..
  if [ ! -f v9.3.2.zip ]; then
    wget https://github.com/dyninst/dyninst/archive/v9.3.2.zip
  fi
  unzip v9.3.2.zip
  cd v9.3.2
  cmake CmakeLists.txt
  make

}

build_dep
clone_all_the_things
build_dyninst
make_all_the_things

