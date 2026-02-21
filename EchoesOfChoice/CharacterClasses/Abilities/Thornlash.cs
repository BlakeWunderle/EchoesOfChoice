using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Thornlash : Ability
    {
        public Thornlash()
        {
            Name = "Thornlash";
            FlavorText = "Thorny vines lash out from the earth, striking the enemy.";
            ModifiedStat = StatEnum.MixedAttack;
            Modifier = 7;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 4;
        }
    }
}
