using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Troll : BaseFighter
    {
        public Troll(int level = 5)
        {
            Level = level;
            Health = Stat(165, 190, 6, 10, 5);
            MaxHealth = Health;
            PhysicalAttack = Stat(30, 35, 2, 4, 5);
            PhysicalDefense = Stat(18, 22, 1, 3, 5);
            MagicAttack = Stat(4, 8, 0, 1, 5);
            MagicDefense = Stat(12, 16, 1, 2, 5);
            Speed = Stat(16, 22, 1, 2, 5);
            Abilities = new List<Ability>() { new Smash(), new Regenerate(), new Stomp() };
            CharacterType = "Troll";
            Mana = Stat(12, 16, 1, 3, 5);
            MaxMana = Mana;
            CritChance = 10;
            CritDamage = 3;
            DodgeChance = 5;
        }

        public Troll(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Troll(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(5, 8);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 3);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 3);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(0, 1);
            MagicDefense += random.Next(1, 2);
            Speed += random.Next(1, 2);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
