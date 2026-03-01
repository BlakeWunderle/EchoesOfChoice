using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Lich : BaseFighter
    {
        public Lich(int level = 14)
        {
            Level = level;
            Health = Stat(280, 320, 8, 12, 14);
            MaxHealth = Health;
            PhysicalAttack = Stat(12, 16, 0, 2, 14);
            PhysicalDefense = Stat(20, 26, 2, 3, 14);
            MagicAttack = Stat(50, 58, 4, 6, 14);
            MagicDefense = Stat(34, 40, 2, 4, 14);
            Speed = Stat(30, 36, 2, 3, 14);
            Abilities = new List<Ability>() { new DeathBolt(), new RaiseDead(), new SoulCage() };
            CharacterType = "Lich";
            Mana = Stat(36, 44, 3, 5, 14);
            MaxMana = Mana;
            CritChance = 25;
            CritDamage = 5;
            DodgeChance = 18;
        }

        public Lich(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Lich(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(6, 9);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 4);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(0, 2);
            PhysicalDefense += random.Next(1, 2);
            MagicAttack += random.Next(2, 4);
            MagicDefense += random.Next(2, 3);
            Speed += random.Next(1, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
