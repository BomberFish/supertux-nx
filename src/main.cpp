//  SuperTux
//  Copyright (C) 2009 Ingo Ruhnke <grumbel@gmail.com>
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

#include <SDL.h>

#include <config.h>
#include <memory>
#if SWITCH
#include <switch.h>
#endif

#include "supertux/main.hpp"

static std::unique_ptr<Main> g_main;

int main(int argc, char** argv)
{
#ifdef SWITCH
  int nxLinkSock = -1;
  sleep(2);
  socketInitializeDefault();
  nxLinkSock = nxlinkStdio();
#endif
  g_main = std::make_unique<Main>();
  int ret = g_main->run(argc, argv);

#if !defined(__EMSCRIPTEN__)
  // Manually destroy, as atexit() functions are called before global
  // destructors and thus would make the destruction crash.
  g_main.reset();
#endif

#ifdef SWITCH
  printf("Exiting with code %d...\n", ret);
  sleep(2);
  if (nxLinkSock >= 0) {
    close(nxLinkSock);
    socketExit();
  }
#endif

  return ret;
}

/* EOF */
