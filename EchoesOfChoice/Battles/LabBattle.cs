using EchoesOfChoice.CharacterClasses.Common;
using System;
using System.Collections.Generic;
using EchoesOfChoice.CharacterClasses.Enemies;

namespace EchoesOfChoice.Battles
{
    public class LabBattle : Battle
    {
        public LabBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new Android() { CharacterName = "Deus" });
            Enemies.Add(new Machinist() { CharacterName = "Ananiah" });
            Enemies.Add(new Ironclad() { CharacterName = "Acrid" });

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
                NextBattle = new MirrorBattle(Units);
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The machines power down one by one, sparks fading to nothing. The building hums its last and goes dark.");
            Console.WriteLine("In the silence a reflection catches the party's eye. A mirror sits on the lab table, its surface impossibly clear.");
            Console.WriteLine("It doesn't reflect the room. It reflects something else entirely.");
            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            var direction = PreviousBattleName == nameof(CaveBattle) ? "west" : "north";
            Console.WriteLine($"Heading {direction}, the air changes. There's a faint charge to it — a prickling on the skin and a taste like iron. Not magic. Something else.");
            Console.WriteLine("A large structure rises from the landscape, all clean angles and dark windows. No signs, no torches. Whatever it runs on, it isn't fire.");
            Console.WriteLine("Inside, the hum is louder. Banks of machinery line the walls. On a central table, something large lies covered by a cloth — something roughly human-shaped.");
            Console.WriteLine("The cloth drops on its own. A laser beam punches through the air and the party dives clear.");
        }
    }
}
