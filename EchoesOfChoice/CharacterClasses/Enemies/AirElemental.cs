using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class AirElemental : BaseFighter
    {
        public AirElemental(int level = 10)
        {
            Level = level;
            Health = Stat(300, 380, 0, 0, 10);
            MaxHealth = Health;
            PhysicalAttack = Stat(48, 60, 0, 0, 10);
            PhysicalDefense = Stat(22, 32, 0, 0, 10);
            MagicAttack = Stat(42, 54, 0, 0, 10);
            MagicDefense = Stat(22, 32, 0, 0, 10);
            Speed = Stat(42, 55, 0, 0, 10);
            Abilities = new List<Ability>() { new GaleForce(), new RazorWind(), new Updraft() };
            CharacterType = "Air Elemental";
            Mana = Stat(55, 75, 0, 0, 10);
            MaxMana = Mana;
            CritChance = 5;
            CritDamage = 4;
            DodgeChance = 3;
        }

        public AirElemental(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new AirElemental(this);
        }

        public override void IncreaseLevel()
        {
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
