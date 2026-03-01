using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class DepthsBattle : Battle
    {
        public DepthsBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new Imp() { CharacterName = "Skritch" });
            Enemies.Add(new CaveSpider() { CharacterName = "Silkfang" });
            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            NextBattle = new StrangerFinalBattle(Units);
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The imp shrieks and vanishes. The spider curls and goes still.");
            Console.WriteLine("The webs part to reveal a passage carved with sigils, leading deeper. The air hums with power. The stranger is close.");
            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("Beneath the city, the tunnels wind downward. The walls are covered in webs thick as rope.");
            Console.WriteLine("An imp darts between the shadows, cackling, while a spider the size of a cart blocks the tunnel ahead.");
            Console.WriteLine("The stranger's last line of defense before the sanctum.");
        }
    }
}
