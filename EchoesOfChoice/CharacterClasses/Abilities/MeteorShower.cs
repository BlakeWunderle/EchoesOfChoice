using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class MeteorShower : Ability
    {
        public MeteorShower()
        {
            Name = "Meteor Shower";
            FlavorText = "A barrage of meteors rains down on all enemies.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 4;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 5;
            TargetAll = true;
        }
    }
}
